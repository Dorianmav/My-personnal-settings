// eslint/.eslintrc.js
module.exports = {
    root: true,
    env: {
      browser: true,
      es2021: true,
      node: true,
    },
    extends: [
      'eslint:recommended',
      '@typescript-eslint/recommended',
      // Garder "prettier" en dernier pour neutraliser les règles stylistiques conflictuelles
      'prettier',
    ],
    parser: '@typescript-eslint/parser',
    parserOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      ecmaFeatures: { jsx: true },
      // Pour activer des règles "type-aware", crée un tsconfig.eslint.json et dé-commente :
      // project: ['./tsconfig.eslint.json'],
    },
    plugins: [
      '@typescript-eslint',
      'simple-import-sort', // tri des imports/exports
      'react',
      'react-hooks',
    ],
    rules: {
      // Erreurs communes
      'no-console': 'warn',
      'no-debugger': 'error',
      // Variables inutilisées -> géré côté TS
      'no-unused-vars': 'off',
      '@typescript-eslint/no-unused-vars': [
        'error',
        { argsIgnorePattern: '^_', varsIgnorePattern: '^_' },
      ],
      // Style / bonnes pratiques
      'prefer-const': 'error',
      'no-var': 'error',
      'object-shorthand': 'error',
      'prefer-arrow-callback': 'error',
      eqeqeq: ['error', 'always'],
      curly: ['error', 'all'],
      'no-eval': 'error',
      'no-implied-eval': 'error',
      'no-new-func': 'error',
      'no-return-assign': 'error',
      'no-sequences': 'error',
      'no-throw-literal': 'error',
      radix: 'error',
      // Async/Await (assouplis)
      'require-await': 'warn',
      'no-return-await': 'off',
      'prefer-promise-reject-errors': 'error',
      // TypeScript
      '@typescript-eslint/explicit-function-return-type': 'off',
      '@typescript-eslint/explicit-module-boundary-types': 'off',
      '@typescript-eslint/no-explicit-any': 'warn',
      '@typescript-eslint/no-non-null-assertion': 'warn',
      '@typescript-eslint/prefer-nullish-coalescing': 'error',
      '@typescript-eslint/prefer-optional-chain': 'error',
      '@typescript-eslint/consistent-type-imports': 'error', // Force `import type`
      '@typescript-eslint/no-import-type-side-effects': 'error', // Évite les side effects
      // Imports (on laisse Prettier gérer le style et on active un tri fiable)
      'import/order': 'off',
      'sort-imports': 'off',
      'simple-import-sort/imports': 'error',
      'simple-import-sort/exports': 'error',
    },
    overrides: [
      // Fichiers de config (vite, vitest, etc.) : autoriser console
      {
        files: ['*.config.js', '*.config.ts', 'vite.config.*', 'vitest.config.*'],
        rules: { 'no-console': 'off' },
      },
      // Tests : activer environnements Jest/Vitest + relâcher certaines règles
      {
        files: ['**/*.test.*', '**/*.spec.*', '**/tests/**/*'],
        env: {
          jest: true,
          vitest: true,
        },
        extends: [
          'plugin:jest/recommended',
          'plugin:vitest/recommended',
          // 'prettier' // pas indispensable ici, déjà au root
        ],
        rules: {
          'no-console': 'off',
          '@typescript-eslint/no-explicit-any': 'off',
        },
      },
      // React / JSX / TSX
      {
        files: ['*.jsx', '*.tsx'],
        extends: ['plugin:react/recommended', 'plugin:react-hooks/recommended'],
        settings: { react: { version: 'detect' } },
        rules: {
          'react/react-in-jsx-scope': 'off', // React 17+
          'react/prop-types': 'off', // TS gère les props
        },
      },
    ],
    ignorePatterns: [
      'dist/',
      'build/',
      'node_modules/',
      '*.min.js',
      'coverage/',
      '.eslintrc.js',
    ],
  };