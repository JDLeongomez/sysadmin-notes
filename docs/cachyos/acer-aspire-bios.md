---
icon: simple/acer
---

# Acer Aspire 7 (A715-74G-75UE): problemas de arranque en CachyOS

![Acer](../assets/logos/acer.svg){ width="64" align="right" }

## 1. Síntomas

- Pantalla con candado y mensaje **"Security Boot Fail"** al encender.
- Al deshabilitar Secure Boot, el sistema se congela en **"Loading initial ramdisk"**.

## 2. Causa raíz

La BIOS tenía dos problemas combinados:

1. **Secure Boot activado** (probablemente reactivado por una actualización de BIOS).
2. **SATA Mode en `RST Premium with Optane`** en lugar de `AHCI`, lo que impide que Linux detecte los discos NVMe.

## 3. Solución paso a paso

1. Entrar a la BIOS pulsando `F2` al arrancar.
   - Contraseña de la BIOS: `1234`
2. Deshabilitar **Secure Boot** (pestaña *Boot*).
3. Pulsar `Ctrl+S` para revelar las opciones ocultas de la BIOS (pestaña *Main*).
4. Cambiar **SATA Mode** de `RST Premium with Optane` → `AHCI`.
5. Guardar con `F10` y reiniciar.

## 4. Notas adicionales

- El menú **GRUB** se activa manteniendo `Shift` o pulsando `Esc` durante el arranque.
