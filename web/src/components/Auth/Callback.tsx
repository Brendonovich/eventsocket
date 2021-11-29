import { useEffect } from "react";
import { MakeGenerics, useNavigate, useSearch } from "react-location";
import { useMutation } from "react-query";

import { authCallback } from "../../utils/api";

const Callback = () => {
  const { code } = useSearch<MakeGenerics<{ Search: { code: string } }>>();
  const navigate = useNavigate();
  
  const { mutate } = useMutation(async (code: string) => {
    await authCallback(code);
    navigate({ to: "/", replace: true });
  });

  useEffect(() => {
    if (!code) navigate({ to: "/", replace: true });
    else mutate(code);
  }, []);

  return <>Loading...</>;
};

export default Callback;
