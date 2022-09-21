import axios, { AxiosError } from "axios";
import { QueryClient } from "@tanstack/query-core";
import { createQuery } from "@adeora/solid-query";
import { useNavigate } from "@solidjs/router";

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  withCredentials: true,
});

export const getAuthRedirect = () => api.get("/auth/redirect");

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

export const getMe = () => api.get("/auth/me").catch((e: AxiosError) => {
  const status = e.response?.status

  if(status !== undefined && Math.floor(status / 100) === 4) return null
  else throw e
});

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

export const createMeQuery = (options?: { enabled?: boolean, retry?: boolean }) => {
  const navigate = useNavigate();

  return createQuery(
    () => ["me"],
    () => getMe().then((r) => r?.data),
    { onError: () => navigate("/"), ...options }
  )
}
