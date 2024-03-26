# Mask Shop System

This is test task for FiveM. This system gives possibility for player to choose, buy and use mask on player model.

## Known Problems

Camera rotation was disabled, because it is not working properly and have lags, also the data storage wasn't implemented

## Installation

1. Clone this repository to your resource folder:
```bash 
git clone https://github.com/Z1ksS/mask-shop.git
```

2. First of all, you need to setup web project for this you need to navigate to the web directory

```bash 
cd web
```

3. Install the dependencies:

```bash
npm install
```

4. Build project for usage

```bash
npm run build
```

5. Setup in your server.cfg file immediate resource initialization after server launch(not necessarily)

ensure coords

6. Run the server from the server-data folder

## Pre-usage steps

1. In game for correct mask chose, you need to setup your model to customizable one with command "model" 
2. You can teleport to the one of the shops by using command "teleport"

After these steps, you can test this system.