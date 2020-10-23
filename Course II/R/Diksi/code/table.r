#install.packages('rJava', type='mac.binary')
#install.packages('xlsx', type='mac.binary')
{
  library("xlsx")
  
  #Устанавливаем директорию
  setwd("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/analytics")
  
  #Цикл по каждому товару. Надеемся на то, что во всех магазах одинаковые товары
  goods.table <- read.table(file = 'store1_price.txt', head = TRUE)
  goods <- goods.table[, 1]
  
  ############ Работаем только с таблицей .csv и .xlsx #########################
  
  for (prod in goods) {
    #Индекс продукта
    element_index <- which(goods.table == prod)
    #Цена продажи
    product_price <- goods.table[element_index, 3]
    #Цена поставки
    supply_price <- goods.table[element_index, 2]
    #Цена утилизации
    util_price <- goods.table[element_index, 4]
    
    #Названия магазинов
    shop_names <- c()
    #Выручка
    shop_revenues <- c()
    #Прибыль
    shop_profits <- c()
    #Реализация
    shop_sales <- c()
    #Списание
    shop_writeoffs <- c()
    #Равномерность продаж
    shop_sr <- c()
    #Продажи макс
    shop_sales_max <- c()
    #День продажи макс
    shop_sales_maxdays <- c()
    #Продажи мин
    shop_sales_min <- c()
    #День продажи мин
    shop_sales_mindays <- c()
    #Списание макс
    shop_writeoff_max <- c()
    #День списания макс
    shop_writeoff_maxdays <- c()
    
    
    #Цикл по каждому магазину
    for (i in 1:10) {
      in1 <-
        read.table(file = paste0('store', as.character(i), '_in.txt'),
                   head = TRUE)
      
      out1 <-
        read.table(file = paste0('store', as.character(i), '_out.txt'),
                   head = TRUE)
      
      
      # Название магазина
      shop_names <-
        append(shop_names, paste0('shop', as.character(i)))
      
      # Списание
      buf_writeoff <- sum(in1[, prod]) - sum(out1[, prod])
      shop_writeoffs <- append(shop_writeoffs, buf_writeoff)
      
      # Выручка
      buf_shoprevenue <- product_price * sum(out1[, prod])
      shop_revenues <- append(shop_revenues, buf_shoprevenue)
      
      # Затраты
      buf_cost <-
        (sum(in1[, prod]) * supply_price) + (buf_writeoff * util_price)
      
      # Прибыль
      shop_profits <-
        append(shop_profits, buf_shoprevenue - buf_cost)
      
      # Реализация
      shop_sales <- append(shop_sales, sum(out1[, prod]))
      
      # Равномерность продаж
      shop_sr <- append(shop_sr, sd(out1[, prod]))
      
      # Продажи макс
      shop_sales_max <- append(shop_sales_max, max(out1[, prod]))
      
      # День продажи макс
      shop_sales_maxdays <-
        append(shop_sales_maxdays, out1[which.max(out1[, prod]), 1])
      
      # Продажи мин
      shop_sales_min <- append(shop_sales_min, min(out1[, prod]))
      
      # День продажи мин
      shop_sales_mindays <-
        append(shop_sales_mindays, out1[which.min(out1[, prod]), 1])
      
      # Списание макс
      shop_writeoff_max <-
        append(shop_writeoff_max, max(c(in1[, prod] - out1[, prod])))
      
      # День списания макс
      shop_writeoff_maxdays <-
        append(shop_writeoff_maxdays, in1[which.max(c(in1[, prod] - out1[, prod])), 1])
    }
    
    #Высчитываем итог и среднее для выручки, прибыли, реализации, списании, равномерности
    shop_names <- c(shop_names, c("Итог", "Среднее"))
    shop_revenues <-
      c(shop_revenues, c(sum(shop_revenues), mean(shop_revenues)))
    shop_profits <-
      c(shop_profits, c(sum(shop_profits), mean(shop_profits)))
    shop_sales <-
      c(shop_sales, c(sum(shop_sales), mean(shop_sales)))
    shop_writeoffs <-
      c(shop_writeoffs, c(sum(shop_writeoffs), mean(shop_writeoffs)))
    shop_sr <- c(shop_sr, c(sum(shop_sr), mean(shop_sr)))
    shop_sales_max <- c(shop_sales_max, c("", ""))
    shop_sales_maxdays <- c(shop_sales_maxdays, c("", ""))
    shop_sales_min <- c(shop_sales_min, c("", ""))
    shop_sales_mindays <- c(shop_sales_mindays, c("", ""))
    shop_writeoff_max <- c(shop_writeoff_max, c("", ""))
    shop_writeoff_maxdays <- c(shop_writeoff_maxdays, c("", ""))
    
    #Формируем датафрейм
    table <-
      data.frame(
        shop_names,
        shop_revenues,
        shop_profits,
        shop_sales ,
        shop_writeoffs,
        shop_sr,
        shop_sales_max,
        shop_sales_maxdays,
        shop_sales_min,
        shop_sales_mindays,
        shop_writeoff_max,
        shop_writeoff_maxdays
      )
    
    #Проставляем заголовки
    col_headings <-
      c(
        "Магазин" ,
        "Выручка, руб" ,
        "Прибыль",
        "Реализация" ,
        "Списание, конт.",
        "Равномерность продаж" ,
        "Продажи макс",
        "День продажи макс",
        "Продажи мин",
        "День продажи мин" ,
        "Списание макс",
        "День макс списания"
      )
    names(table) <- col_headings
    
    # Запись в .csv
    write.table(
      table,
      file = paste0(
        "/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/таблица_",
        prod,
        ".csv"
      ),
      col.names = TRUE,
      row.names = FALSE,
      sep = ';',
      dec = ',',
      fileEncoding = 'UTF-8'
    )
    
    # Запись в .xlsx (это чтоб на маке отображалось корректно)
    write.xlsx(
      table,
      file = paste0(
        "/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/таблица_",
        prod,
        ".xlsx"
      ),
      sheetName = "DATA",
      col.names = TRUE,
      row.names = FALSE,
      append = FALSE
    )
  }
  
  
  ######################## Формируем графики ###################################
  
  
  #Общая выручка со всех магазинов и со всех продуктов
  super_summ_shoprevenue  <- rep(0,7)
  #Общая прибыль со всех магазинов и со всех продуктов
  super_summ_shopprofits <- rep(0,7)
  #Общее списание со всех магазинов и со всех продуктов
  super_summ_writeoffs <- rep(0,7)
  
  #Цикл по каждому магазу
  for (i in 1:10) {
    in1 <- read.table(file = paste0('store',as.character(i),'_in.txt'), head = TRUE)
    out1 <- read.table(file = paste0('store',as.character(i),'_out.txt'), head = TRUE)
    
    #График объёма продаж товарав в первом магазине по дням
    png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/shop",as.character(i),"/Объём продаж магазин ",as.character(i),".png"),width=600, height=350)
    xrange = range(seq(1,7))
    yrange = range(in1[,"Кофе"], in1[,"Молоко"], in1[,"Творог"])
    
    graph <- plot(xrange,
         yrange,
         main=paste0('Объём продаж в магазине ',as.character(i)), 
         xlab="День недели", 
         ylab="Количество проданного товара, шт",
         type = "n",
         ylim=c(1,150)
         ) 
  
    points(seq(1,7),out1[, "Кофе"], pch=20, col="red3")
    lines(seq(1,7),out1[, "Кофе"], pch=20, col="red3")
    points(seq(1,7),out1[, "Молоко"], pch=22, col="forestgreen")
    lines(seq(1,7),out1[, "Молоко"], pch=22, col="forestgreen")
    points(seq(1,7),out1[, "Творог"], pch=24, col="steelblue")
    lines(seq(1,7),out1[, "Творог"], pch=24, col="steelblue")
    legend("topright", legend=c("Кофе", "Молоко", "Творог"),col=c("red3", "forestgreen", "steelblue"), pch=c(20,22,24))
    dev.off()
  
    price1 <- read.table(file = paste0('store',as.character(i),'_price.txt'), head = TRUE)
    
    #Цикл по каждому продукту в каждом магазине
    
    #Общая выручка со всех продуктов
    summ_shopprofits <- rep(0,7)
    summ_shoprevenue <- rep(0,7)
    summ_writeoffs <- rep(0,7)
    for (prod in goods){
    
      element_index <- which(goods.table == prod)
      #Цена продажи
      product_price <- goods.table[element_index, 3]
      #Цена поставки
      supply_price <- goods.table[element_index, 2]
      #Цена утилизации
      util_price <- goods.table[element_index, 4]
      
      # Выручка
      buf_shoprevenue <- product_price * out1[, prod]
      png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/shop",as.character(i),"/Выручка магазин ",as.character(i)," (",prod,").png"),width=600, height=350)
      plot(buf_shoprevenue, main=paste0('Выручка по дням в магазине ',as.character(i),' (',prod,')'), xlab='День', ylab=paste0("Выручка по товару '",prod,"', руб."),type='o')
      dev.off()
      
      # Списание
      buf_writeoff <- in1[, prod] - out1[, prod]
      xrange = range(seq(1,7))
      yrange = range(buf_writeoff)
      png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/shop",as.character(i),"/Списание магазин ",as.character(i)," (",prod,").png"),width=600, height=350)
      plot(xrange,
           yrange,
           main=paste0('Списание ',prod,' в ',as.character(i),' магазине'), 
           xlab="День", 
           ylab="Списание, шт.",
           type = "n"
           )
      points(seq(1,7), buf_writeoff, pch=19, col="red")
      lines(seq(1,7), buf_writeoff, pch=19, col="black")
      dev.off()
      
      # Затраты
      buf_cost <- (in1[, prod] * supply_price) + (buf_writeoff * util_price)
      # Прибыль
      shop_profits <- buf_shoprevenue - buf_cost
      
      png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/shop",as.character(i),"/Прибыль магазин ",as.character(i)," (",prod,").png"),width=600, height=350)
      plot(shop_profits, main=paste0('Прибыль по дням в ',as.character(i),' магазине (',prod,')'), xlab='День', ylab='Прибыль, .руб.',type='S')
      dev.off()
      
      
      #Прибавляем к сумме выручки
      summ_shoprevenue <- summ_shoprevenue + buf_shoprevenue
      #Прибавляем к сумме прибыли
      summ_shopprofits <- summ_shopprofits + shop_profits
      #Прибавляем к сумме списаний
      summ_writeoffs <- summ_writeoffs + buf_writeoff
    
    }
    
    
    #Строим общий график выручки по дням
    png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/shop",as.character(i),"/Общая выручка магазин ",as.character(i),".png"),width=600, height=350)
    plot(summ_shoprevenue, main=paste0('Выручка по дням в магазине ',as.character(i)), xlab='День', ylab=paste0("Общая выручка, руб."),type='o')
    dev.off()
    
    #Строим общий график прибыли по дням
    png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/shop",as.character(i),"/Общая прибыль магазин ",as.character(i),".png"),width=600, height=350)
    plot(summ_shopprofits, main=paste0('Прибыль по дням в магазине ',as.character(i)), xlab='День', ylab='Общая прибыль, руб.',type='S')
    dev.off()
    
    #Строим общий график списаний по дням
    xrange = range(seq(1,7))
    yrange = range(summ_writeoffs)
    png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/shop",as.character(i),"/Общее списание магазин ",as.character(i),".png"),width=600, height=350)
    plot(xrange,yrange,main=paste0('Списания по дням в ',as.character(i),' магазине'), xlab="День", ylab="Списание, шт.", type = "n")
    points(seq(1,7), summ_writeoffs, pch=19, col="red")
    lines(seq(1,7), summ_writeoffs, pch=19, col="black")
    dev.off()
    
    #TODO РЕНТАБЕЛЬНОСТЬ?
    
    #Прибавляем выручку к общей выручке
    super_summ_shoprevenue <- super_summ_shoprevenue + summ_shoprevenue
    #Прибавляем прибыль к общей прибыли
    super_summ_shopprofits <- super_summ_shopprofits + summ_shopprofits
    #Прибавляем списания к общим списаниям
    super_summ_writeoffs <- super_summ_writeoffs + summ_writeoffs
  }
  
  
  #Строим график общей выручки
  png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/Общая выручка.png"), width=600, height=350)
  plot(super_summ_shoprevenue, main='Выручка во всех магазинах по дням', xlab='День', ylab="Общая выручка, руб.",type='o')
  dev.off()
  
  #Строим график общей прибыли
  png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/Общая прибыль.png"), width=600, height=350)
  plot(super_summ_shopprofits, main='Прибыль во всех магазинах по дням', xlab='День', ylab='Общая прибыль, руб.',type='S')
  dev.off()
  
  #Строим график общих списаний
  xrange = range(seq(1,7))
  yrange = range(super_summ_writeoffs)
  png(file=paste0("/Users/georgiydemo/Projects/FA/Course II/R/Diksi/result/graph/Общее списание.png"),width=600, height=350)
  plot(xrange,yrange,main='Списание во всех магазинах по дням', xlab="День", ylab="Списание, шт.", type = "n")
  points(seq(1,7), super_summ_writeoffs, pch=19, col="red")
  lines(seq(1,7), super_summ_writeoffs, pch=19, col="black")
  dev.off()
  
  

}
