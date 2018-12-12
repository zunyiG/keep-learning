module.exports = {
  title: 'Front-end-programming',
  description: 'Front end programming',
  themeConfig: {
    nav: [
      {
        text: 'Home',
        link: '/'
      }
    ],
    sidebar: {
      '/functional-programming/js-fp/': [
        '',
        'purity',
        'curry',
        'compose',
        'hindley-milner',
        'example',
        'functor',
        'monad',
        'applicative',
        'appendix'
      ],
      '/': [
        ''
      ]
    },
    sidebarDepth: 2
  }
}
