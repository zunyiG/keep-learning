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
      '/react/react-tutorial/': [
        '',
        '01.jsx',
        '02.render',
        '03.components',
        '04.state',
        '05.event'
      ],
      '/': [
        ''
      ]
    },
    sidebarDepth: 2
  }
}
