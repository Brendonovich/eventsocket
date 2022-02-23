import axios from "axios";
import { QueryClient } from "react-query";

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  withCredentials: true,
});

function getAuthRedirect() {
  return api.get("/auth/redirect");
}

api.interceptors.response.use(
  (res) => res,
  async ({ response }) => {
    if ([401, 403].includes(response.status)) {
      console.log("cringe");
      const res = await getAuthRedirect();

      document.location.href = res.data;
    }
  }
);

export const queryClient = new QueryClient();

export const authCallback = (code: string) =>
  api.post(
    "/auth/authorize",
    {},
    {
      params: {
        code,
      },
    }
  );

export const getMe = () => api.get("/auth/me");

export const generateAPIKey = () => api.post("/auth/generate_api_key");

export const logout = () => api.post("/auth/logout");

export const getSubscriptions = () =>
  api.get<
    {
      id: string;
      type: string;
    }[]
  >("/eventsub/subscriptions");

export const deleteSubscription = (id: string) =>
  api.delete("/eventsub/subscriptions", { params: { id } });

export const createSubscription = (type: string) =>
  api.post("/eventsub/subscriptions", { type });
