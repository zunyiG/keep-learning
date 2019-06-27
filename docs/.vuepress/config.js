module.exports = {
  title: 'Keep learning',
  description: 'keep learning',
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
        '02.typeclass',
        '03.function',
        '04.recursion',
        '05.high-order',
        '06.module'
      ],
      '/typescript/':[
        '',
        '01.types',
        '02.variable',
        '03.interface'
      ],
      '/front-end-framework/': [
        ''
      ],
      '/computer-program/': [
        '',
        '01.abstraction-building'
      ],
      '/programming-language/': [
        ''
      ],
      '/koa/':[
        ''
      ],
      '/': [
        ''
      ]
    },
    sidebarDepth: 2
  }
}
