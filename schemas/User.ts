import { list } from "@keystone-6/core";
import {
  text,
  password,
  timestamp,
  select,
  relationship,
} from "@keystone-6/core/fields";

export const User = list({
  access: {
    operation: {
      create: ({ session }) => session?.data.role === "admin",
      query: ({ session }) =>
        session?.data.role === "admin" || session?.data.role === "manager",
      update: ({ session }) => session?.data.role === "admin",
      delete: ({ session }) => session?.data.role === "admin",
    },
    filter: {
      query: ({ session }) => {
        if (session?.data.role === "admin") {
          return true; // Admin tüm kullanıcıları görebilir
        }
        if (session?.data.role === "manager") {
          return {
            managedMalls: {
              some: {
                managers: {
                  some: { id: { equals: session?.data.id } },
                },
              },
            },
          };
        }
        return false; // Diğer roller hiçbir kullanıcıyı göremez
      },
    },
  },
  ui: {
    labelField: "fullName",
    listView: {
      initialColumns: ["fullName", "email", "role", "managedMalls"],
    },
  },
  fields: {
    fullName: text({ validation: { isRequired: true } }),
    email: text({ validation: { isRequired: true }, isIndexed: "unique" }),
    password: password({ validation: { isRequired: true } }),
    managedMalls: relationship({
      ref: "Mall.managers",
      many: true,
    }),
    role: select({
      options: [
        { label: "Manager", value: "manager" },
        { label: "Admin", value: "admin" },
      ],
      defaultValue: "manager",
    }),
    createdAt: timestamp({ defaultValue: { kind: "now" } }),
    updatedAt: timestamp({ db: { updatedAt: true } }),
  },
});
