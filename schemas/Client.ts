import { list } from "@keystone-6/core";
import { text, timestamp, relationship } from "@keystone-6/core/fields";

export const Client = list({
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
          return true; // Admin tüm Client verilerini görebilir
        }
        if (session?.data.role === "manager") {
          return {
            stores: {
              mall: {
                managers: {
                  some: { id: { equals: session?.data.id } },
                },
              },
            },
          }; // Manager yalnızca kendi yönettiği Mall'lara bağlı Client'leri görebilir
        }
        return false; // Diğer roller hiçbir veriyi göremez
      },
    },
  },
  ui: {
    labelField: "fullName",
    listView: {
      initialColumns: ["fullName", "email", "phoneNumber", "stores"],
    },
  },
  fields: {
    fullName: text({
      validation: { isRequired: true },
    }),
    phoneNumber: text(),
    email: text({
      validation: { isRequired: true },
      isIndexed: "unique",
    }),
    createdAt: timestamp({ defaultValue: { kind: "now" } }),
    updatedAt: timestamp({ db: { updatedAt: true } }),
    stores: relationship({
      ref: "Store",
      many: false,
    }),
  },
});
