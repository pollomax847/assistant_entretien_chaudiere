/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  
  // Configure trailing slashes in URLs
  trailingSlash: false,
  
  // Properly serve static assets with correct MIME types
  async headers() {
    return [
      {
        source: '/js/:path*',
        headers: [
          {
            key: 'Content-Type',
            value: 'application/javascript; charset=utf-8',
          }
        ],
      },
      {
        source: '/css/:path*',
        headers: [
          {
            key: 'Content-Type',
            value: 'text/css; charset=utf-8',
          }
        ],
      },
    ];
  },

  // Redirect /public to root
  async redirects() {
    return [
      {
        source: '/public',
        destination: '/',
        permanent: true,
      },
    ];
  },
};

module.exports = nextConfig;
