import { useNavigate, useSearchParams } from "@solidjs/router";
import { createMutation } from "@adeora/solid-query";

import { authCallback, queryClient } from "../../utils/api";

export default () => {
  const [params] = useSearchParams<{ code: string }>();
  const navigate = useNavigate();

  const callback = createMutation(async (code: string) => {
    const res = await authCallback(code);
    queryClient.setQueryData(["me"], res.data);
    navigate("/", { replace: true });
  });

  if (!params.code) navigate("/", { replace: true });
  else callback.mutate(params.code);

  return (
    <div class="w-full h-full flex items-center justify-center">
      <div class="p-6 bg-gray-800 rounded-2xl text-2xl font-bold border border-gray-700">
        <h1>Logging in...</h1>
      </div>
    </div>
  );
};
