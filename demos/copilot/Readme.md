# Light Sensor Use Case Demo using the Copilot Framework

## Instructions

1) Debian or Ubuntu Docker env

```
docker run -it ubuntu:22.04
```

2) Install copilot

```
# Notes from https://github.com/Copilot-Language/copilot?tab=readme-ov-file#other-linux-distributions

sudo apt update
sudo apt-get install -y ghc cabal-install      #  install a Haskell compiler (GHC)
cabal update
cabal v2-install --lib copilot              #  install Copilot from Hackage
ghci <<< 'import Language.Copilot'          #  test that Copilot is available - success is - ghci> ghci> Leaving GHCi.
```

3) Clone use case codebase

Proposing to stage this work in `https://github.com/elisa-tech/wg-aerospace/tree/main/demos/copilot`.

```
git clone https://github.com/elisa-tech/wg-aerospace.git
```


4) Build Copilot compile monitor

5) Build / stage test apps

6) Launch sequence
   1) Start copilot log and Ethernet monitor (bound to localhost)
   2) Bind light app to localhost
   3) Bind light server to localhost
   4) Run client with arg to change state (run x3 to cycle through all transitions - on off on)


## Observations

TBD
