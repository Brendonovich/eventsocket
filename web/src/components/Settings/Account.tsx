import { useMutation, useQuery } from "react-query";
import { logout } from "../../utils/api";

const Account = () => {
  const { data: me } = useQuery<{ display_name: string }>("me");

  const logoutMutation = useMutation(async () => {
    await logout();
    window.location.reload();
  });

  return (
    <div>
      <span className="text-2xl font-medium">Account</span>
      <p className="mt-1 text-gray-200">
        Currently logged in as <strong>{me!.display_name}</strong>.
      </p>
      <button
        className="bg-red-600 px-2 py-1 rounded-lg mt-2"
        onClick={() => logoutMutation.mutate()}
      >
        Logout
      </button>
    </div>
  );
};

export default Account;
