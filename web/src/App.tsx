import { Outlet, useMatchRoute } from "react-location";
import { useQuery } from "react-query";

import { getMe } from "./utils/api";
import Navbar from "./components/Navbar";

function App() {
  const routeMatch = useMatchRoute();

  const isUnauthedRoute = !!routeMatch({ to: "auth/*" });

  const { isLoading } = useQuery(
    "me",
    async () => {
      const res = await getMe();
      return res.data;
    },
    { enabled: !isUnauthedRoute }
  );

  if (isUnauthedRoute) return <Outlet />;

  return (
    <div className="bg-gray-800 w-screen h-screen text-white flex flex-col">
      {isLoading ? null : (
        <>
          <Navbar />
          <Outlet />
        </>
      )}
    </div>
  );
}

export default App;
