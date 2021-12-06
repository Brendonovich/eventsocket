import { useMutation, useQuery } from "react-query";
import { logout } from "../../utils/api";
import Section from "./Section";

const Account = () => {
  const { data: me } = useQuery<{ display_name: string }>("me");

  const logoutMutation = useMutation(async () => {
    await logout();
    window.location.reload();
  });

  return (
    <Section
      title="Account"
      description={
        <>
          Currently logged in as <strong>{me!.display_name}</strong>
        </>
      }
      footer={
        <button
          className="bg-red-600 px-4 py-1 rounded-lg ml-auto"
          onClick={() => logoutMutation.mutate()}
        >
          Logout
        </button>
      }
    />
  );
};

export default Account;
