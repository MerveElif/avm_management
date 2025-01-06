// keystone.ts
import "dotenv/config";
import { config } from "@keystone-6/core";
import { createAuth } from "@keystone-6/auth";
import { statelessSessions } from "@keystone-6/core/session";
import { Mall } from "./schemas/Mall";
import { Store } from "./schemas/Store";
import { Payment } from "./schemas/Payment";
import { Client } from "./schemas/Client";
import { User } from "./schemas/User";

const { withAuth } = createAuth({
  listKey: "User",
  identityField: "email",
  secretField: "password",
  sessionData: "id role",
  initFirstItem: {
    fields: ["fullName", "email", "password", "role"],
  },
});

export default withAuth(
  config({
    db: {
      provider: "mysql",
      url: process.env.DATABASE_URL || "",
    },
    lists: {
      Mall,
      Store,
      Client,
      Payment,
      User,
    },
    session: statelessSessions({
      secret: process.env.SESSION_SECRET || "",
    }),
    ui: {
      isAccessAllowed: ({ session }) => !!session?.data,
      pageMiddleware: async (isValidSession) => {
        if (!isValidSession) {
          return { kind: "redirect", to: "/no-access" };
        }
      },
      publicPages: ["/custom-public"],
    },
  })
);
