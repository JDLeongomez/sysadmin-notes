# UPS — APC Back-UPS BE850M2 (apcupsd)

UPS conectado por USB al servidor para apagado automático en cortes de luz largos.
Modelo: APC Back-UPS BE850M2, 850VA / 450W.

## Instalación

​```bash
sudo apt update && sudo apt install apcupsd
​```

## Configuración

Verificar que apcupsd esté habilitado en `/etc/default/apcupsd`:

​```
ISCONFIGURED=yes
​```

En `/etc/apcupsd/apcupsd.conf`:

​```
UPSCABLE usb
UPSTYPE usb
DEVICE
​```

**Importante:** `DEVICE` debe quedar vacío con `UPSTYPE usb` (autodetección).
Por defecto el archivo trae `/dev/ttyS0`, que es para conexión serial, no USB. Hay que borrarlo.

Umbrales de apagado:

​```
BATTERYLEVEL 5
MINUTES 3
TIMEOUT 0
​```

Apaga cuando la batería llegue a 5% o queden menos de 3 minutos estimados, lo que ocurra primero.

## Aplicar cambios

​```bash
sudo systemctl restart apcupsd
sudo systemctl enable apcupsd
​```

## Verificar estado

​```bash
apcaccess status
​```

Campos clave:

- `STATUS`: `ONLINE` (normal) / `ONBATT` (en batería, corte detectado)
- `BCHARGE`: porcentaje de carga
- `TIMELEFT`: minutos de autonomía estimados
- `LOADPCT`: porcentaje de carga del UPS en uso (consumo real del servidor)

## Probar sin desconectar

​```bash
sudo apctest
​```

Menú interactivo para simular condiciones sin riesgo.

## Notas

- Batería instalada: 2024-12-23 (vida útil esperada 2-5 años, revisar reemplazo ~2027-2029)
- Batería de repuesto: modelo RBC17
- Consumo real del servidor: ~2% de carga del UPS (~9W), autonomía estimada >3 horas