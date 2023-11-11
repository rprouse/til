# Setup a Yarn Project with TypeScript in VS Code

```sh
# Install Yarn globally
npm install -g yarn

# Install Yarn for the project
yarn set version berry

# Install dependencies
yarn add -D typescript
yarn add -D ts-node
yarn add -D @types/node
yarn add -D @yarnpkg/pnpify

# Setup in VSCode
yarn dlx @yarnpkg/sdks vscode
```
