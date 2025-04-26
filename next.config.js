/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    domains: ['example.com'], // Ajoutez les domaines autorisés pour les images
    unoptimized: true
  },
  webpack: (config) => {
    config.module.rules.push({
      test: /\.(pdf|svg|jpg|png)$/,
      use: {
        loader: 'file-loader',
        options: {
          name: '[name].[ext]',
          publicPath: '/_next/static/media/',
          outputPath: 'static/media/',
        },
      },
    });
    return config;
  },
};

module.exports = nextConfig;
