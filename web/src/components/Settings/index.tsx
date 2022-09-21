import { APIKey } from "./APIKey";
import { Account } from "./Account";

export default () => {
  return (
    <div class="w-full mx-auto overflow-y-auto max-w-2xl p-4 space-y-6">
      <Account />
      <APIKey />
    </div>
  );
};
