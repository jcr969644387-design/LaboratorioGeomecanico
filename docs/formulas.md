# Fórmulas y tablas utilizadas

> Todas las tablas de este documento son **simplificadas con fines
> educativos** y pueden variar según la metodología adoptada por el
> docente, la empresa o la norma aplicable.

---

## 1. RMR — Rock Mass Rating

### 1.1 Fórmula

```
RMR = A1 + A2 + A3 + A4 + A5 + B
```

| Símbolo | Parámetro | Máximo |
| --- | --- | --- |
| A1 | Resistencia a la compresión uniaxial de la roca intacta | 15 |
| A2 | RQD | 20 |
| A3 | Espaciamiento de discontinuidades | 20 |
| A4 | Condición de las discontinuidades | 30 |
| A5 | Agua subterránea | 15 |
| B | Ajuste por orientación de discontinuidades | 0 a -12 |

El resultado se acota a la escala configurable **0 – 100**.

### 1.2 A1 · Resistencia a compresión uniaxial

| UCS (MPa) | Puntaje |
| --- | --- |
| > 250 | 15 |
| 100 – 250 | 12 |
| 50 – 100 | 7 |
| 25 – 50 | 4 |
| 5 – 25 | 2 |
| 1 – 5 | 1 |
| < 1 | 0 |

### 1.3 A2 · RQD

| RQD (%) | Puntaje |
| --- | --- |
| 90 – 100 | 20 |
| 75 – 90 | 17 |
| 50 – 75 | 13 |
| 25 – 50 | 8 |
| < 25 | 3 |

### 1.4 A3 · Espaciamiento de discontinuidades

| Espaciamiento (m) | Puntaje |
| --- | --- |
| > 2 | 20 |
| 0.6 – 2 | 15 |
| 0.2 – 0.6 | 10 |
| 0.06 – 0.2 | 8 |
| < 0.06 | 5 |

### 1.5 A4 · Condición de las discontinuidades

| Condición | Puntaje |
| --- | --- |
| Muy buena: muy rugosa, discontinua, sin separación, sin alteración | 30 |
| Buena: rugosa, separación < 1 mm, paredes poco alteradas | 25 |
| Regular: poco rugosa, separación < 1 mm, paredes muy alteradas | 20 |
| Mala: pulida o relleno blando < 5 mm, separación 1 – 5 mm | 10 |
| Muy mala: relleno blando > 5 mm o separación > 5 mm | 0 |

### 1.6 A5 · Agua subterránea

| Condición | Puntaje |
| --- | --- |
| Seco | 15 |
| Húmedo | 10 |
| Mojado | 7 |
| Goteo | 4 |
| Flujo continuo | 0 |

### 1.7 B · Ajuste por orientación (labores subterráneas)

| Orientación | Ajuste |
| --- | --- |
| Muy favorable | 0 |
| Favorable | -2 |
| Regular | -5 |
| Desfavorable | -10 |
| Muy desfavorable | -12 |

### 1.8 Clasificación del macizo

| RMR | Clase | Calidad | Riesgo |
| --- | --- | --- | --- |
| 81 – 100 | I | Roca muy buena | Bajo |
| 61 – 80 | II | Roca buena | Bajo |
| 41 – 60 | III | Roca regular | Medio |
| 21 – 40 | IV | Roca mala | Alto |
| 0 – 20 | V | Roca muy mala | Alto |

---

## 2. Sistema Q de Barton

### 2.1 Fórmula

```
Q = (RQD / Jn) x (Jr / Ja) x (Jw / SRF)
```

| Cociente | Significado físico |
| --- | --- |
| RQD / Jn | Tamaño relativo del bloque |
| Jr / Ja | Resistencia al corte entre bloques |
| Jw / SRF | Esfuerzo activo sobre la excavación |

Convención aplicada: si `RQD < 10`, se utiliza `RQD = 10`.

### 2.2 Jn · Número de familias de discontinuidades

| Condición | Jn |
| --- | --- |
| Macizo masivo | 0.5 – 1 |
| Una familia | 2 |
| Una familia más juntas aleatorias | 3 |
| Dos familias | 4 |
| Dos familias más aleatorias | 6 |
| Tres familias | 9 |
| Tres familias más aleatorias | 12 |
| Cuatro o más familias | 15 |
| Roca triturada | 20 |

### 2.3 Jr · Rugosidad

| Condición | Jr |
| --- | --- |
| Junta discontinua | 4 |
| Rugosa u ondulada | 3 |
| Lisa ondulada | 2 |
| Rugosa plana | 1.5 |
| Lisa plana | 1 |
| Espejo de falla plano | 0.5 |

### 2.4 Ja · Alteración o relleno

| Condición | Ja |
| --- | --- |
| Paredes selladas con relleno duro | 0.75 |
| Paredes sanas, sin alteración | 1 |
| Alteración ligera | 2 |
| Relleno limoso o arenoso | 3 |
| Relleno arcilloso blando | 4 |
| Relleno arcilloso grueso | 8 |
| Relleno arcilloso expansivo | 12 |

### 2.5 Jw · Factor de agua

| Condición | Jw |
| --- | --- |
| Seco o goteo mínimo | 1 |
| Flujo medio | 0.66 |
| Flujo importante en roca competente | 0.5 |
| Flujo importante con lavado de relleno | 0.33 |
| Flujo excepcional decreciente | 0.2 |
| Flujo excepcional permanente | 0.1 |

### 2.6 SRF · Factor de reducción por esfuerzos

| Condición | SRF |
| --- | --- |
| Esfuerzos favorables | 1 |
| Esfuerzos bajos, cerca de superficie | 2.5 |
| Zona de corte aislada | 5 |
| Varias zonas de corte | 7.5 |
| Esfuerzos altos, estallido leve | 10 |
| Roca fluyente o expansiva | 15 |

### 2.7 Categoría cualitativa del macizo

| Q | Categoría |
| --- | --- |
| 400 – 1000 | Excepcionalmente buena |
| 100 – 400 | Extremadamente buena |
| 40 – 100 | Muy buena |
| 10 – 40 | Buena |
| 4 – 10 | Regular |
| 1 – 4 | Mala |
| 0.1 – 1 | Muy mala |
| 0.01 – 0.1 | Extremadamente mala |
| 0.001 – 0.01 | Excepcionalmente mala |

### 2.8 Correlación educativa RMR – Q

```
RMR ≈ 9 · ln(Q) + 44        (Bieniawski, valor acotado a 0 – 100)
```

Se usa únicamente para estimar la **consistencia** entre ambas
clasificaciones y calcular el nivel de confianza de la recomendación.

---

## 3. Reglas de selección básica de sostenimiento

La aplicación calcula un **índice de exigencia** entre 0 y 5:

```
exigencia = base(RMR) + mod(Q) + mod(luz) + mod(tipo de labor) + mod(riesgo)
```

### 3.1 Exigencia base según RMR

| RMR | Base |
| --- | --- |
| 81 – 100 | 0 |
| 61 – 80 | 1 |
| 41 – 60 | 2 |
| 21 – 40 | 3 |
| 0 – 20 | 4 |

### 3.2 Modificadores

| Criterio | Condición | Modificador |
| --- | --- | --- |
| Índice Q | Q < 0.1 | +2 |
| Índice Q | 0.1 ≤ Q < 1 | +1 |
| Índice Q | Q ≥ 40 | -1 |
| Luz de excavación | > 10 m | +2 |
| Luz de excavación | 5 – 10 m | +1 |
| Tipo de labor | Producción, cámara o rampa | +1 |
| Riesgo operativo | Alto | +1 |

El resultado se acota al rango **0 – 5**.

### 3.3 Sistema recomendado por nivel

| Nivel | Sistema preliminar |
| --- | --- |
| 0 | Sin sostenimiento inmediato (solo desatado y control visual) |
| 1 | Pernos de roca puntuales |
| 2 | Pernos de roca sistemáticos |
| 3 | Pernos más malla metálica |
| 4 | Pernos más shotcrete |
| 5 | Pernos, shotcrete reforzado y cerchas metálicas |

### 3.4 Nivel de confianza

Se compara el RMR ingresado con el RMR equivalente estimado a partir de Q:

| Diferencia | Confianza |
| --- | --- |
| ≤ 8 puntos | Alta |
| ≤ 15 puntos | Media |
| > 15 puntos, o luz > 15 m, o Q fuera de 0.01 – 400 | Baja |

---

## 4. Advertencia

Estas fórmulas y tablas se emplean con fines exclusivamente didácticos.
El sistema Q no debe aplicarse fuera de su contexto geomecánico y ninguna
recomendación generada por la aplicación constituye un diseño definitivo
de sostenimiento.
