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
      '/functional-programming/': [
        '',
        'purity',
        'curry',
        'compose',
        'hindley-milner',
        'example',
        'functor',
        'monad',
        'applicative'
      ],
      '/': [
        ''
      ]
    },
    sidebarDepth: 2
  }
}
