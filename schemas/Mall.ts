import { list } from "@keystone-6/core";
import { text, timestamp, relationship } from "@keystone-6/core/fields";

export const Mall = list({
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
          return true;
        }
        return { managers: { some: { id: { equals: session?.data.id } } } };
      },
    },
  },
  ui: {
    labelField: "name",
    listView: {
      initialColumns: ["name", "city", "address", "managers"],
    },
    hideCreate: ({ session }) => session?.data.role !== "admin", // Sadece admin "create" görebilir
    hideDelete: ({ session }) => session?.data.role !== "admin", // Sadece admin "delete" görebilir
  },
  fields: {
    name: text({
      validation: { isRequired: true },
      ui: {
        itemView: {
          fieldMode: ({ session }) =>
            session?.data.role === "admin" ? "edit" : "read",
        }, // Alanı admin düzenleyebilir, manager okuyabilir
      },
    }),
    city: text({
      ui: {
        itemView: {
          fieldMode: ({ session }) =>
            session?.data.role === "admin" ? "edit" : "read",
        },
      },
    }),
    address: text({
      ui: {
        itemView: {
          fieldMode: ({ session }) =>
            session?.data.role === "admin" ? "edit" : "read",
        },
      },
    }),
    createdAt: timestamp({
      defaultValue: { kind: "now" },
      ui: { itemView: { fieldMode: "read" } }, // Herkese sadece okuma izni
    }),
    updatedAt: timestamp({
      db: { updatedAt: true },
      ui: { itemView: { fieldMode: "read" } }, // Herkese sadece okuma izni
    }),
    managers: relationship({
      ref: "User.managedMalls",
      many: true,
      ui: {
        itemView: {
          fieldMode: ({ session }) =>
            session?.data.role === "admin" ? "edit" : "read",
        },
      },
    }),
  },
});
