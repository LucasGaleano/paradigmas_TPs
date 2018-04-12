{-# LANGUAGE NoMonomorphismRestriction #-}
import Text.Show.Functions -- Para mostrar <Function> en consola cada vez que devuelven una
import Data.List -- Para métodos de colecciones que no vienen por defecto (ver guía de lenguajes)
import Data.Maybe -- Por si llegan a usar un método de colección que devuelva “Just suElemento” o “Nothing”.
import Test.Hspec


------------TEST---------------------------------

usuarioCon10Monedas = Usuario "Pepe" 10 10 
  

ejecutarTest = hspec $ do

  it "Depositar 10 más. Debería quedar con 20 monedas." $ (billetera.deposita 10) usuarioCon10Monedas  `shouldBe` 20 
  it "Extraer 3: Debería quedar con 7" $ (billetera.extraccion 3) usuarioCon10Monedas `shouldBe` 7
  it "Extraer 15: Debería quedar con 0" $ (billetera .extraccion 15) usuarioCon10Monedas `shouldBe` 0
  it "Un upgrade: Debería quedar con 12." $  (billetera.upgrade) usuarioCon10Monedas `shouldBe` 12
  it "Cerrar la cuenta: 0." $ billetera (cierraCuenta usuarioCon10Monedas) `shouldBe` 0
  it "Queda igual: 10." $ (billetera.quedaIgual) usuarioCon10Monedas `shouldBe` 10
  it "Depositar 1000, y luego tener un upgrade: 1020." $ (billetera.upgrade.deposita 1000) usuarioCon10Monedas `shouldBe` 1020
  it "Toco y me voy, deberia quedar con 0." $ (billetera.tocoMeVoy) usuarioCon10Monedas `shouldBe` 0
  it "ahorrante errante, deberia quedar con 34." $ (billetera.ahorranteErrante) usuarioCon10Monedas `shouldBe` 34




-----------TIPOS DE DATOS-----------------

type Transaccion = Usuario
type Evento = Usuario

data Usuario = Usuario {
  nombre :: String,
  billetera :: Float,
  nivel :: Int
} deriving (Show) 

--------------USUARIOS-------------------

pepe = Usuario "Jose" 10 0
lucho = Usuario "luciano" 2 0

-----------EVENTOS-------------------------
quedaIgual usuario = usuario
nuevaBilletera unMonto unUsuario = unUsuario {billetera = unMonto}
cierraCuenta usuario = nuevaBilletera 0 usuario
subeNivel usuario = usuario {nivel = nivel usuario + 1 , billetera = (billetera usuario) * 1.2}
deposita unMonto usuario = nuevaBilletera ((billetera usuario) +  unMonto) usuario
tocoMeVoy usuario = (cierraCuenta.upgrade.deposita 15) usuario
ahorranteErrante usuario = (deposita 10 .upgrade .deposita 8 .extraccion 1 .deposita 2 .deposita 1) usuario


extraccion unMonto usuario
  | (billetera usuario) - unMonto < 0 = nuevaBilletera 0 usuario
  | otherwise = nuevaBilletera ((billetera usuario) - unMonto) usuario

upgrade usuario
  | (billetera.subeNivel) usuario - billetera usuario < 10 = subeNivel usuario
  | otherwise = nuevaBilletera (billetera usuario + 10) usuario

------------------TRANSACCIONES------------------

luchoCierraLaCuenta :: Transaccion -> Evento
luchoCierraLaCuenta unUsuario | nombre unUsuario == nombre lucho = cierraCuenta unUsuario
                              | otherwise = quedaIgual unUsuario

pepeDeposita5Monedas :: Transaccion -> Evento
pepeDeposita5Monedas unUsuario | nombre unUsuario == nombre pepe = deposita 5 unUsuario
                               | otherwise = quedaIgual unUsuario 

luchoTocaYSeVa :: Transaccion -> Evento
luchoTocaYSeVa unUsuario unUsuario | nombre unUsuario == nombre lucho = tocoMeVoy unUsuario
                                   | otherwise = quedaIgual unUsuario 

luchoEsUnAhorranteErrante :: Transaccion -> Evento
luchoEsUnAhorranteErrante unUsuario | nombre unUsuario == nombre lucho = ahorranteErrante unUsuario
                                    | otherwise = quedaIgual unUsuario 










