import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Prohesis - Web3 Prediction Markets",
  description: "Decentralized prediction markets powered by Base",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>
        {children}
      </body>
    </html>
  );
}
