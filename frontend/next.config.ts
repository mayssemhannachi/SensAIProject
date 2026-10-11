import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Required for Docker production build (standalone output)
  output: "standalone",
  turbopack: {
    root: process.cwd(),
  },
};

export default nextConfig;
