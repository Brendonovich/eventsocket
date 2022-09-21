import { createQuery, createMutation } from "@adeora/solid-query";
import { useNavigate } from "@solidjs/router";
import { logout, queryClient } from "../../utils/api";
import Section from "./Section";

export const Account = () => {
  const me = createQuery<{ display_name: string }>(() => ["me"]);
  const navigate = useNavigate() 

  const logoutMutation = createMutation(async () => {
    await logout();
    queryClient.invalidateQueries(["me"])
    navigate("/")
  });

  if (!me.data) return null;

  return (
    <Section
      title="Account"
      description={
        <>
          Currently logged in as <strong>{me.data.display_name}</strong>
        </>
      }
      footer={
        <button
          class="bg-red-600 px-4 py-1 rounded-lg ml-auto"
          onClick={() => logoutMutation.mutate()}
        >
          Logout
        </button>
      }
    />
  );
};
