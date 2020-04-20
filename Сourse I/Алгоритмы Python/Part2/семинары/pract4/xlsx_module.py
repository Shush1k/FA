"""Модуль для формирования отчетов в файл MS Excel"""

import pandas as pd
import xlsxwriter
class XlsxClass():

    OUT_XLSX_FILE = "отчет.xlsx"

    def __init__(self, obj_list):
        self.obj_list = obj_list
        self.processing()
    
    def transpose(self, l):
        return [list(e) for e in list(zip(*l))]

    def report_processing(self, report_dict):
        """Формирование главного отчета из словаря"""
        cert1_list, cert2_list = [], []
        for student, cert in report_dict.items():
            buf_list = 

        report_dict

    def converter(self, d_input):
        try:
            return d_input.strftime("%d.%m.%Y")
        except AttributeError:
            return "-"
    def processing(self):
        
        c = self.converter
        report_dict = {}
        student_list, work_list, exam_list, cert_list = [], [], [], []
        for obj in self.obj_list:
            student_list.append([obj.name, obj.group, obj.course, obj.points, obj.mark])
            report_dict[obj.name] = {"cert": {}, "info" : {"points" : obj.points, "mark" : obj.mark}}
            #Аттестации 
            for cert in obj.cert_obj_list:
                cert_list.append([obj.name, cert.name, cert.points, c(cert.date_begin), c(cert.date_end)])
                report_dict[obj.name]["cert"][cert.name] = []
                for work in cert.work_obj_list:
                    report_dict[obj.name]["cert"][cert.name].append([work.name, work.work_type, work.points, c(work.date_deadline), c(work.date_completed), c(work.date_protected), work.work_completed, work.work_protected])
                    work_list.append([obj.name, cert.name, work.name, work.work_type, work.points, c(work.date_deadline), c(work.date_completed), c(work.date_protected), work.work_completed, work.work_protected])
        
        for obj in self.obj_list:
            exam_list.append([obj.exam_obj.name, obj.exam_obj.points])
        
        student_list = dict(zip(["ФИО","Группа","Курс","Баллы","Оценка"], self.transpose(student_list)))
        exam_list = dict(zip(["Название", "Баллы"],self.transpose(exam_list)))
        cert_list = dict(zip(["Студент", "Название", "Баллы", "Дата начала", "Дата конца"], self.transpose(cert_list)))
        work_list = dict(zip(["Студент","Аттестация","Название работы", "Тип работы", "Баллы", "Дата дедлайна", "Дата завершения", "Дата защиты", "Завершена", "Защищена"], self.transpose(work_list)))

        self.report_processing(report_dict)
        df0 = pd.DataFrame(student_list)
        df1 = pd.DataFrame(student_list)
        df2 = pd.DataFrame(work_list)
        df3 = pd.DataFrame(cert_list)
        df4 = pd.DataFrame(exam_list)

        # Create a Pandas Excel writer using XlsxWriter as the engine.
        writer = pd.ExcelWriter(XlsxClass.OUT_XLSX_FILE, engine='xlsxwriter')

        # Write each dataframe to a different worksheet.
        df0.to_excel(writer, sheet_name='Аттестация 1', index=False)
        df0.to_excel(writer, sheet_name='Аттестация 2', index=False)
        df1.to_excel(writer, sheet_name='Студенты', index=False)
        df2.to_excel(writer, sheet_name='Работы', index=False)
        df3.to_excel(writer, sheet_name='Аттестации', index=False)
        df4.to_excel(writer, sheet_name='Экзамены', index=False)

        # Close the Pandas Excel writer and output the Excel file.
        writer.save()
        print(report_dict)
        
