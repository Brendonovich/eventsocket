import { createMutation } from "@adeora/solid-query";

import Section from "./Section";
import { generateAPIKey } from "../../utils/api";
import { Show } from "solid-js";

export const APIKey = () => {
  const generate = createMutation(async () => {
    const res = await generateAPIKey();
    return res.data as string;
  });

  return (
    <Section
      title="API Key"
      description="Use your API key to make requests to EventSocket from your application"
      footer={
        <>
          <p class="mr-4 text-gray-400">
            Generating a new API key will invalidate your current key
          </p>
          <button
            class="bg-white text-black rounded-md px-4 py-1 ml-auto"
            onClick={() => generate.mutateAsync()}
          >
            Generate
          </button>
        </>
      }
    >
      <Show when={generate.data}>
        <div class="py-2 px-3 bg-gray-900 mt-4 rounded-md border border-gray-700">
          {generate.data}
        </div>
      </Show>
    </Section>
  );
};
