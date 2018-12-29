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
        '05.event',
        '06.ifelse',
        '07.list',
        '08.form',
        '09.lifting',
        '10.composition'
      ],
      '/haskell/': [
        '',
        '01.types',
        '02.typeclass'
      ],
      '/': [
        ''
      ]
    },
    sidebarDepth: 2
  }
}
