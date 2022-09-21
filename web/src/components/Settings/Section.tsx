import { JSXElement } from "solid-js";

interface Props {
  title: string;
  description: JSXElement;
  footer: JSXElement;
  children?: JSXElement;
}

const Section = ({ title, description, children, footer }: Props) => (
  <div class="border border-gray-700 rounded-md overflow-hidden">
    <div class="p-5">
      <span class="text-2xl font-medium">{title}</span>
      <p class="mt-2 text-gray-200">{description}</p>
      {children}
    </div>
    <div class="bg-gray-900 px-5 py-4 flex items-center">{footer}</div>
  </div>
);

export default Section;
