module.exports = ({ env }) => ({
  upload: {
    config: {
      provider: 'cloudinary',
      providerOptions: {
        cloud_name: env('CLOUDINARY_NAME'),
        api_key: env('CLOUDINARY_KEY'),
        api_secret: env('CLOUDINARY_SECRET'),
      },
      actionOptions: {
        upload: {
          upload_preset: 'cms-tomatoro',
        },
        uploadStream:{
          upload_preset: 'cms-tomatoro',
        },
        delete: {},
      },
    },
  },
  'import-export-entries': {
    enabled: true,
    config: {
      // See `Config` section.
    },
  },
});
