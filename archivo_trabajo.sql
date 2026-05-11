-- =============================================
-- LogicWeb UTA - Base de Datos
-- Universidad Técnica de Ambato
-- Carrera de Ingeniería en Software
-- =============================================

-- 1. CREAR LA BASE DE DATOS
CREATE DATABASE LogicWebDB;
GO

-- Usar la base de datos creada
USE LogicWebDB;
GO

-- =============================================
-- 2. CREACIÓN DE TABLAS
-- =============================================

-- Tabla: Usuario
CREATE TABLE Usuario (
    IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Correo NVARCHAR(100) UNIQUE NOT NULL,
    Contraseña NVARCHAR(255) NOT NULL,
    Rol NVARCHAR(50) DEFAULT 'Estudiante' CHECK (Rol IN ('Estudiante', 'Docente', 'Administrador')),
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

-- Tabla: Tema
CREATE TABLE Tema (
    IdTema INT IDENTITY(1,1) PRIMARY KEY,
    NombreTema NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(MAX),
    Unidad INT NOT NULL CHECK (Unidad BETWEEN 1 AND 4),
    Orden INT NOT NULL
);
GO

-- Tabla: Ejercicio
CREATE TABLE Ejercicio (
    IdEjercicio INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(200) NOT NULL,
    Enunciado NVARCHAR(MAX) NOT NULL,
    Categoria NVARCHAR(50) CHECK (Categoria IN ('Básico', 'Intermedio', 'Avanzado')),
    Dificultad INT CHECK (Dificultad BETWEEN 1 AND 5),
    SolucionEsperada NVARCHAR(MAX),
    ExplicacionPasoPaso NVARCHAR(MAX),
    IdTema INT NOT NULL,
    Puntos INT DEFAULT 10,
    FOREIGN KEY (IdTema) REFERENCES Tema(IdTema) ON DELETE CASCADE
);
GO

-- Tabla: IntentoEjercicio (historial de práctica)
CREATE TABLE IntentoEjercicio (
    IdIntento INT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario INT NOT NULL,
    IdEjercicio INT NOT NULL,
    RespuestaUsuario NVARCHAR(MAX),
    EsCorrecto BIT NOT NULL,
    FechaIntento DATETIME DEFAULT GETDATE(),
    TiempoSegundos INT,
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario),
    FOREIGN KEY (IdEjercicio) REFERENCES Ejercicio(IdEjercicio)
);
GO

-- Tabla: ProgresoUsuario (resumen por tema)
CREATE TABLE ProgresoUsuario (
    IdProgreso INT IDENTITY(1,1) PRIMARY KEY,
    IdUsuario INT NOT NULL,
    IdTema INT NOT NULL,
    EjerciciosCompletados INT DEFAULT 0,
    EjerciciosCorrectos INT DEFAULT 0,
    PuntosAcumulados INT DEFAULT 0,
    UltimaActividad DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (IdUsuario) REFERENCES Usuario(IdUsuario),
    FOREIGN KEY (IdTema) REFERENCES Tema(IdTema),
    CONSTRAINT UQ_UsuarioTema UNIQUE (IdUsuario, IdTema)
);
GO

-- =============================================
-- 3. INSERCIÓN DE DATOS INICIALES
-- =============================================

-- Insertar Temas según las unidades del PDF
INSERT INTO Tema (NombreTema, Descripcion, Unidad, Orden) VALUES
('Lógica de Programación', 'Conceptos fundamentales de lógica para resolver problemas', 1, 1),
('Algoritmos y Pseudocódigo', 'Diseño de algoritmos y representación en pseudocódigo', 1, 2),
('Diagramas de Flujo', 'Representación visual de algoritmos con símbolos estándar', 1, 3),
('Variables y Tipos de Datos', 'Declaración y uso de variables en programación', 2, 4),
('Operadores Aritméticos y Lógicos', 'Operaciones matemáticas y comparaciones lógicas', 2, 5),
('Estructuras Condicionales', 'Uso de if-else y switch para toma de decisiones', 2, 6),
('Estructuras Repetitivas - Ciclos', 'Bucles for, while y do-while', 2, 7),
('Programación Orientada a Objetos', 'Clases, objetos, atributos y métodos', 3, 8),
('Arreglos y Listas', 'Manejo de colecciones de datos', 4, 9);
GO

-- Insertar Usuarios de prueba
INSERT INTO Usuario (Nombre, Correo, Contraseña, Rol) VALUES
('Estudiante Demo', 'estudiante@uta.edu.ec', '123456', 'Estudiante'),
('Docente Demo', 'docente@uta.edu.ec', 'docente123', 'Docente'),
('Administrador', 'admin@logicweb.edu.ec', 'admin2024', 'Administrador');
GO

-- Insertar Ejercicios de ejemplo (basados en los ejercicios de vida real del PDF)
INSERT INTO Ejercicio (Titulo, Enunciado, Categoria, Dificultad, SolucionEsperada, ExplicacionPasoPaso, IdTema, Puntos) VALUES
-- Ejercicios Unidad 1 - Lógica
('Promedio de Notas', 
'Calcular el promedio de 3 notas de un estudiante y determinar si aprueba (promedio >= 7). Entradas: nota1, nota2, nota3. Proceso: sumar y dividir entre 3. Salida: promedio y mensaje "Aprobado" o "Reprobado".', 
'Básico', 1, 
'promedio = (nota1 + nota2 + nota3) / 3; si promedio >= 7 entonces "Aprobado" sino "Reprobado"',
'1. Solicitar las 3 notas al usuario. 2. Sumar las 3 notas. 3. Dividir la suma entre 3. 4. Comparar si el promedio es mayor o igual a 7. 5. Mostrar el resultado.', 
1, 10),

('Cálculo de Sueldo con Horas Extras',
'Calcular el sueldo de un empleado. Si trabaja más de 40 horas, las horas extra se pagan al doble. Entradas: horasTrabajadas, pagoPorHora.',
'Intermedio', 3,
'si horas <= 40: sueldo = horas * pago; sino: sueldo = 40 * pago + (horas - 40) * pago * 2',
'1. Leer horas trabajadas y pago por hora. 2. Verificar si horas > 40. 3. Calcular sueldo base y horas extra según corresponda. 4. Mostrar sueldo total.',
2, 15),

-- Ejercicios Unidad 2 - Condicionales
('Descuento en Tienda',
'Aplicar descuento según el monto de compra: 10% si compra > $100, 15% si compra > $200, 20% si compra > $500.',
'Intermedio', 2,
'si monto > 500: descuento = 0.20; sino si monto > 200: descuento = 0.15; sino si monto > 100: descuento = 0.10; sino: descuento = 0',
'1. Leer monto de compra. 2. Evaluar condiciones en orden descendente. 3. Calcular descuento y total a pagar. 4. Mostrar resultados.',
6, 15),

('Clasificación por Edades',
'Determinar categoría según edad: 0-12: Niño, 13-17: Adolescente, 18-59: Adulto, 60+: Adulto Mayor.',
'Básico', 1,
'si edad <= 12: "Niño"; sino si edad <= 17: "Adolescente"; sino si edad <= 59: "Adulto"; sino: "Adulto Mayor"',
'1. Solicitar edad. 2. Validar que sea número positivo. 3. Evaluar rangos de edad. 4. Mostrar categoría correspondiente.',
6, 10),

-- Ejercicios Unidad 2 - Ciclos
('Control de Ventas Diarias',
'Registrar ventas del día hasta que se ingrese 0. Mostrar total de ventas y cantidad de ventas realizadas.',
'Intermedio', 3,
'total = 0; contador = 0; repetir: leer venta; si venta != 0: total += venta; contador++ hasta venta == 0',
'1. Inicializar acumuladores. 2. Bucle mientras venta != 0. 3. Acumular total y contar ventas. 4. Mostrar resultados finales.',
7, 20),

('Tabla de Multiplicar',
'Generar la tabla de multiplicar de un número del 1 al 10 usando un ciclo for.',
'Básico', 1,
'para i desde 1 hasta 10: mostrar numero + " x " + i + " = " + (numero * i)',
'1. Solicitar número. 2. Usar ciclo for de 1 a 10. 3. Calcular y mostrar cada multiplicación.',
7, 10),

-- Ejercicios Unidad 3 - POO
('Gestión de Cuenta Bancaria',
'Crear clase CuentaBancaria con atributos: titular, saldo. Métodos: depositar(monto) y retirar(monto) con validación de saldo suficiente.',
'Avanzado', 4,
'clase CuentaBancaria: atributos titular, saldo; método depositar(monto): saldo += monto; método retirar(monto): si monto <= saldo: saldo -= monto; sino: "Saldo insuficiente"',
'1. Definir clase con constructor. 2. Implementar método depositar. 3. Implementar método retirar con validación. 4. Probar con instancia de ejemplo.',
8, 25),

('Registro de Estudiantes',
'Crear clase Estudiante con nombre, edad y notas. Método para calcular promedio y determinar si aprueba.',
'Intermedio', 3,
'clase Estudiante: constructor(nombre, edad, notas[]); método promedio(): sumar notas / cantidad; método aprobado(): promedio >= 7',
'1. Definir atributos de la clase. 2. Crear método para calcular promedio. 3. Crear método para verificar aprobación. 4. Crear objeto de prueba.',
8, 20),

-- Ejercicios Unidad 4 - Arreglos
('Inventario de Productos',
'Manejar un arreglo de productos con nombre y precio. Mostrar el producto más caro y el promedio de precios.',
'Intermedio', 3,
'recorrer arreglo: encontrar máximo precio; calcular suma total / cantidad',
'1. Definir arreglo de productos. 2. Recorrer para encontrar máximo. 3. Calcular suma y promedio. 4. Mostrar resultados.',
9, 20),

('Consumo de Energía en el Hogar',
'Registrar consumo de energía de 6 meses en un arreglo. Calcular consumo total, promedio mensual y mes de mayor consumo.',
'Avanzado', 4,
'total = suma(consumos); promedio = total / 6; mesMayor = índice del máximo valor',
'1. Crear arreglo con 6 valores. 2. Calcular suma total. 3. Calcular promedio. 4. Encontrar índice del valor máximo.',
9, 25);
GO

-- Insertar algunos intentos de ejemplo para reportes
INSERT INTO IntentoEjercicio (IdUsuario, IdEjercicio, RespuestaUsuario, EsCorrecto) VALUES
(1, 1, 'promedio = 8.5 - Aprobado', 1),
(1, 4, 'Adulto', 1),
(1, 2, 'sueldo = 550', 0),
(2, 1, 'promedio = 7.0 - Aprobado', 1),
(2, 6, 'Tabla del 5 generada', 1);
GO

-- Inicializar progreso para usuarios de prueba
INSERT INTO ProgresoUsuario (IdUsuario, IdTema, EjerciciosCompletados, EjerciciosCorrectos, PuntosAcumulados)
SELECT 
    1, 
    IdTema, 
    ISNULL((SELECT COUNT(*) FROM IntentoEjercicio ie JOIN Ejercicio e ON ie.IdEjercicio = e.IdEjercicio WHERE ie.IdUsuario = 1 AND e.IdTema = Tema.IdTema), 0),
    ISNULL((SELECT COUNT(*) FROM IntentoEjercicio ie JOIN Ejercicio e ON ie.IdEjercicio = e.IdEjercicio WHERE ie.IdUsuario = 1 AND e.IdTema = Tema.IdTema AND ie.EsCorrecto = 1), 0),
    ISNULL((SELECT SUM(e.Puntos) FROM IntentoEjercicio ie JOIN Ejercicio e ON ie.IdEjercicio = e.IdEjercicio WHERE ie.IdUsuario = 1 AND e.IdTema = Tema.IdTema AND ie.EsCorrecto = 1), 0)
FROM Tema;
GO

-- =============================================
-- 4. CONSULTAS DE VERIFICACIÓN
-- =============================================

PRINT '=== VERIFICACIÓN DE DATOS CREADOS ===';
PRINT '';

SELECT 'Total Temas: ' + CAST(COUNT(*) AS VARCHAR) FROM Tema;
SELECT 'Total Ejercicios: ' + CAST(COUNT(*) AS VARCHAR) FROM Ejercicio;
SELECT 'Total Usuarios: ' + CAST(COUNT(*) AS VARCHAR) FROM Usuario;

PRINT '';
PRINT '=== EJERCICIOS POR CATEGORÍA ===';
SELECT Categoria, COUNT(*) AS Cantidad FROM Ejercicio GROUP BY Categoria;

PRINT '';
PRINT '=== BASE DE DATOS LogicWebDB CREADA EXITOSAMENTE ===';
GO

select * from Usuario;
select * from Ejercicio;
select * from progresousuario;
select * from intentoejercicio;
select * from tema;

