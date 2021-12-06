import { useMutation } from "react-query";

import Section from "./Section";
import { generateAPIKey } from "../../utils/api";

const APIKey = () => {
  const generate = useMutation(async () => {
    const res = await generateAPIKey();
    return res.data as string;
  });

  return (
    <Section
      title="API Key"
      description="Use your API key to make requests to EventSocket from your application"
      footer={
        <>
          <p className="mr-4 text-gray-400">
            Generating a new API key will invalidate your current key
          </p>
          <button
            className="bg-white text-black rounded-md px-4 py-1 ml-auto"
            onClick={() => generate.mutateAsync()}
          >
            Generate
          </button>
        </>
      }
    >
      {generate.data && (
        <div className="py-2 px-3 bg-gray-900 mt-4 rounded-md border border-gray-700">
          {generate.data}
        </div>
      )}
    </Section>
  );
};

export default APIKey;
