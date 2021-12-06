import React, { FC, ReactNode } from "react";

interface Props {
  title: string;
  description: ReactNode;
  footer: ReactNode;
}
const Section: FC<Props> = ({
  title,
  description,
  children,
  footer,
}) => (
  <div className="border border-gray-700 rounded-md overflow-hidden">
    <div className="p-5">
      <span className="text-2xl font-medium">{title}</span>
      <p className="mt-2 text-gray-200">{description}</p>
      {children}
    </div>
    <div className="bg-gray-900 px-5 py-4 flex items-center">
      {footer}
    </div>
  </div>
);

export default Section;
