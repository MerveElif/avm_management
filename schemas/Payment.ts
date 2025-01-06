import { list } from "@keystone-6/core";
import {
  decimal,
  timestamp,
  select,
  relationship,
  calendarDay,
} from "@keystone-6/core/fields";

export const Payment = list({
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
          return true; // Admin tüm kayıtları görebilir
        }
        return {
          store: {
            mall: {
              managers: {
                some: { id: { equals: session?.data.id } }, // IDFilter kullanımı
              },
            },
          },
        }; // Manager sadece kendi yönettiği mall içindeki store'lara ait payment'ları görebilir
      },
    },
  },
  ui: {
    labelField: "amount",
    listView: {
      initialColumns: ["store", "client", "amount", "paymentDate", "status"],
    },
  },
  fields: {
    amount: decimal({
      scale: 2,
      precision: 10,
      validation: { isRequired: true },
    }),
    paymentDate: calendarDay({
      validation: { isRequired: true },
    }),
    status: select({
      options: [
        { label: "Paid", value: "paid" },
        { label: "Late", value: "late" },
        { label: "Pending", value: "pending" },
        { label: "Partially Paid", value: "partially_paid" },
      ],
      defaultValue: "paid",
    }),
    store: relationship({
      ref: "Store",
      many: false,
    }),
    client: relationship({
      ref: "Client",
      many: false,
    }),
  },
});
