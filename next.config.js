/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  
  // Configure trailing slashes in URLs
  trailingSlash: false,
  
  // Configure static file handling
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=31536000, immutable',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
        ],
      },
      {
        // Set proper content types for JavaScript files
        source: '/js/:path*',
        headers: [
          {
            key: 'Content-Type',
            value: 'application/javascript; charset=utf-8',
          }
        ],
      },
      {
        // Set proper content types for CSS files
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

  // Redirect /public to /
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
