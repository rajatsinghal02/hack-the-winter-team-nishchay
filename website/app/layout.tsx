import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "JalTejas | Autonomous Systems",
  description: "Next-generation autonomous drone and ROV technology engineered for extreme environments.",
  icons: {
    icon: '/icon.png',
    shortcut: '/icon.png',
    apple: '/icon.png',
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body suppressHydrationWarning>
        {children}
      </body>
    </html>
  );
}
