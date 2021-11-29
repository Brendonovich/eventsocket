import { useMutation } from "react-query";

import { generateAPIKey } from "../../utils/api";

const APIKey = () => {
  const generate = useMutation(async () => {
    const res = await generateAPIKey();
    return res.data as string;
  });

  return (
    <div>
      <span className="text-2xl font-medium">API Key</span>
      <p className="mt-1 text-gray-200">
        Use your API key to make requests to EventSocket from your application.
        <br />
        You must keep this confidential.
        <br />
        Generating a new API key will invalidate your current key.
      </p>
      {generate.data && (
        <div className="py-2 px-3 bg-gray-900 my-1 rounded-md">
          {generate.data}
        </div>
      )}
      <button
        className="bg-blue-500 rounded-md px-2 py-1 mt-2"
        onClick={() => generate.mutateAsync()}
      >
        Generate
      </button>
    </div>
  );
};

export default APIKey;
