"""
Задача 7:
Вычислить сумму модулей элементов массива, расположенных после первого отрицательного
элемента.
Например, в массиве [5, 3, -1, 8, 0, -6, 1] первый отрицательный элемент является третьим
по счету, а сумма модулей стоящих после него элементов массива будет составлять 8 + 0 + 6
+ 1 = 15.
"""
import numpy as np
from random import randint
def main():
    try:
        n = int(input("Введите кол-во элементов в массиве -> "))
    except ValueError:
        print("Некорректный ввод данных!")
        return
    np_arr = np.array([randint(-100,100) for _ in range(n)])
    print("Исходный массив:", np_arr)

    #Индекс
    itemindex = np.where(np_arr < 0)[0][0]
    print("Индекс первого отрицательного элемента: {}".format(itemindex))
    #Новый массив
    new_arr = np_arr[itemindex+1:]
    #Сумма по молулю
    s = np.sum((np.absolute(new_arr)))
    print("Сумма модулей после отрицательного элемента: {}".format(s))

    #new_arr = np_arr[(np_arr < a ) | (np_arr > b)]
    #np_arr = np.pad(np_arr, (0, np_arr.shape[0] - new_arr.shape[0]))
    #print(np_arr)

if __name__ == "__main__":
    main()