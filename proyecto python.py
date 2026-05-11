# ============================================
# PROYECTO: SISTEMA DE GESTION DE ESTUDIANTES
# ============================================

estudiantes = []
notas = []


# ============================================
# FUNCION PARA AGREGAR ESTUDIANTES
# ============================================

def agregar_estudiante():

    nombre = input("Ingrese el nombre del estudiante: ")

    while True:

        try:
            nota = float(input("Ingrese la nota del estudiante: "))

            if nota >= 0 and nota <= 10:
                break

            else:
                print("La nota debe estar entre 0 y 10")

        except:
            print("Ingrese un numero valido")

    estudiantes.append(nombre)
    notas.append(nota)

    print("Estudiante agregado correctamente")


# ============================================
# FUNCION PARA MOSTRAR ESTUDIANTES
# ============================================

def mostrar_estudiantes():

    if len(estudiantes) == 0:
        print("No existen estudiantes registrados")

    else:

        print("\n===== LISTA DE ESTUDIANTES =====")

        for i in range(len(estudiantes)):

            print(
                str(i + 1) + ".",
                estudiantes[i],
                "- Nota:",
                notas[i]
            )


# ============================================
# FUNCION PARA CALCULAR PROMEDIO
# ============================================

def calcular_promedio():

    if len(notas) == 0:

        print("No existen notas registradas")

    else:

        suma = 0

        for nota in notas:
            suma += nota

        promedio = suma / len(notas)

        print("Promedio general:", round(promedio, 2))


# ============================================
# FUNCION PARA BUSCAR ESTUDIANTE
# ============================================

def buscar_estudiante():

    if len(estudiantes) == 0:

        print("No existen estudiantes")

    else:

        buscar = input("Ingrese el nombre a buscar: ")

        encontrado = False

        for i in range(len(estudiantes)):

            if estudiantes[i].lower() == buscar.lower():

                print("\n===== ESTUDIANTE ENCONTRADO =====")
                print("Nombre:", estudiantes[i])
                print("Nota:", notas[i])

                encontrado = True

        if encontrado == False:
            print("Estudiante no encontrado")


# ============================================
# FUNCION PARA MOSTRAR MAYOR NOTA
# ============================================

def estudiante_mayor_nota():

    if len(notas) == 0:

        print("No existen estudiantes")

    else:

        mayor = notas[0]
        posicion = 0

        for i in range(len(notas)):

            if notas[i] > mayor:

                mayor = notas[i]
                posicion = i

        print("\n===== MAYOR NOTA =====")
        print("Estudiante:", estudiantes[posicion])
        print("Nota:", mayor)


# ============================================
# FUNCION PARA GUARDAR RESULTADOS
# ============================================

def guardar_resultados():

    try:

        with open("resultados.txt", "w", encoding="utf-8") as archivo:

            archivo.write(
                "===== RESULTADOS DE ESTUDIANTES =====\n\n"
            )

            for i in range(len(estudiantes)):

                archivo.write(
                    estudiantes[i]
                    + " - Nota: "
                    + str(notas[i])
                    + "\n"
                )

            if len(notas) > 0:

                suma = 0

                for nota in notas:
                    suma += nota

                promedio = suma / len(notas)

                archivo.write(
                    "\nPromedio General: "
                    + str(round(promedio, 2))
                )

        print("Resultados guardados correctamente")

    except Exception as e:

        print("Error al guardar el archivo")
        print(e)


# ============================================
# MENU PRINCIPAL
# ============================================

while True:

    print("\n========== MENU ==========")
    print("1. Agregar estudiante")
    print("2. Mostrar estudiantes")
    print("3. Calcular promedio")
    print("4. Buscar estudiante")
    print("5. Mostrar mayor nota")
    print("6. Guardar resultados")
    print("7. Salir")

    opcion = input("Seleccione una opcion: ")

    # ========================================

    if opcion == "1":

        agregar_estudiante()

    elif opcion == "2":

        mostrar_estudiantes()

    elif opcion == "3":

        calcular_promedio()

    elif opcion == "4":

        buscar_estudiante()

    elif opcion == "5":

        estudiante_mayor_nota()

    elif opcion == "6":

        guardar_resultados()

    elif opcion == "7":

        print("Programa finalizado")
        break

    else:

        print("Opcion invalida")