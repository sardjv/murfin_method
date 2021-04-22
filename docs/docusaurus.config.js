/** @type {import('@docusaurus/types').DocusaurusConfig} */
module.exports = {
  title: 'Murfin+',
  tagline: 'Documentation',
  url: 'https://sardjv.github.io',
  baseUrl: '/murfin_plus/',
  //onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',
  organizationName: 'sardjv', // Usually your GitHub org/user name.
  projectName: 'murfin_method', // Usually your repo name.
  themeConfig: {
    navbar: {
      title: 'Murfin+',
      logo: {
        alt: 'Murfin+',
        src: 'img/logo.svg', // TODO
      },
      items: [
        {
          to: 'docs/quickstart',
          activeBasePath: 'docs',
          label: 'Docs',
          position: 'left',
        },
        {
          href: 'https://github.com/sardjv/murfin_method/edit/master/docs',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Quickstart',
              to: 'docs/quickstart',
            },
            {
              label: 'Technical Overview',
              to: 'docs/overview',
            },
            {
              label: 'Requirements',
              to: 'docs/requirements',
            },
            {
              label: 'Development',
              to: 'docs/development',
            },
            {
              label: 'Documentation',
              to: 'docs/documentation',
            },
            {
              label: 'Versioning',
              to: 'docs/versioning',
            }
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'SARD JV',
              href: 'https://sardjv.co.uk/',
            },
            {
              label: 'Oxleas NHS Foundation Trust',
              href: 'http://oxleas.nhs.uk/',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/sardjv',
            },
          ],
        },
        {
          title: 'More',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/sardjv/esr_api',
            },
          ],
        },
      ],
      copyright: `Built with <a href='https://docusaurus.io/'>Docusaurus</a>. Illustrations by <a href='https://www.drawkit.io/free'>Drawkit</a>.`,
    },
  },
  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          editUrl:
            'https://github.com/sardjv/murfin_method/edit/master/docs',
        },
        blog: {
          showReadingTime: true,
          // Please change this to your repo.
          editUrl:
            'https://github.com/facebook/docusaurus/edit/master/website/blog/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],
};
