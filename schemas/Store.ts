import { graphql, list } from "@keystone-6/core";
import {
  text,
  timestamp,
  integer,
  relationship,
  virtual,
} from "@keystone-6/core/fields";

export const Store = list({
  access: {
    operation: {
      create: ({ session }) =>
        session?.data.role === "admin" || session?.data.role === "manager",
      query: ({ session }) =>
        session?.data.role === "admin" || session?.data.role === "manager",
      update: ({ session }) =>
        session?.data.role === "admin" || session?.data.role === "manager",
      delete: ({ session }) => session?.data.role === "admin",
    },
    filter: {
      query: ({ session }) => {
        if (session?.data.role === "admin") {
          return true; // Admin tüm store'ları görebilir
        }
        if (session?.data.role === "manager") {
          return {
            mall: {
              managers: {
                some: { id: { equals: session?.data.id } },
              },
            },
          }; // Manager sadece kendi yönettiği Mall'lara ait Store'ları görebilir
        }
        return false; // Diğer roller hiçbir Store'u göremez
      },
      update: ({ session }) => {
        if (session?.data.role === "admin") {
          return true; // Admin tüm store'ları güncelleyebilir
        }
        if (session?.data.role === "manager") {
          return {
            mall: {
              managers: {
                some: { id: { equals: session?.data.id } },
              },
            },
          }; // Manager sadece kendi yönettiği Mall'lara ait Store'ları güncelleyebilir
        }
        return false; // Diğer roller güncelleme yapamaz
      },
    },
  },
  ui: {
    labelField: "storeWithMall",
    listView: {
      initialColumns: ["storeWithMall", "floorNumber"],
    },
  },
  fields: {
    storeName: text({
      validation: { isRequired: true },
    }),
    floorNumber: integer(),
    createdAt: timestamp({ defaultValue: { kind: "now" } }),
    updatedAt: timestamp({ db: { updatedAt: true } }),
    mall: relationship({
      ref: "Mall",
      many: false,
    }),
    storeWithMall: virtual({
      field: graphql.field({
        type: graphql.String,
        resolve: async (item, args, context) => {
          // Store ve Mall bilgilerini al
          const storeWithMall = await context.query.Store.findOne({
            where: { id: String(item.id) }, // id'yi açıkça string olarak dönüştürüyoruz
            query: `
              storeName
              mall {
                name
              }
            `,
          });

          const mallName = storeWithMall.mall?.name || "No Mall";
          return `${storeWithMall.storeName} - ${mallName}`;
        },
      }),
    }),
  },
});
