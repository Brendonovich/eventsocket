import APIKey from "./APIKey";
import Account from "./Account"

const Settings = () => {
  return (
    <div className="w-full mx-auto overflow-y-auto max-w-2xl p-4 space-y-6">
      <Account />
      <APIKey />
    </div>
  );
};

export default Settings;
