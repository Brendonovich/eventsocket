import { useEffect } from "react";
import { MakeGenerics, useNavigate, useSearch } from "react-location";
import { useMutation } from "react-query";

import { authCallback, queryClient } from "../../utils/api";

const Callback = () => {
  const { code } = useSearch<MakeGenerics<{ Search: { code: string } }>>();
  const navigate = useNavigate();

  const { mutate } = useMutation(async (code: string) => {
    const res = await authCallback(code);
    queryClient.setQueryData("me", res.data);
    navigate({ to: "/", replace: true });
  });

  useEffect(() => {
    if (!code) navigate({ to: "/", replace: true });
    else mutate(code);
  }, []);

  return (
    <div className="w-full h-full flex items-center justify-center">
      <div className="p-6 bg-gray-800 rounded-2xl text-2xl font-bold border border-gray-700">
        <h1>Logging in...</h1>
      </div>
    </div>
  );
};

export default Callback;
