import streamlit as st
from docx import Document
from docx.shared import Inches, Mm

def make_a4(document):
    section = document.sections[0]
    section.page_height = Mm(297)
    section.page_width = Mm(210)

def set_margins(document):
    for section in document.sections:
        section.left_margin = Mm(12)
        section.right_margin = Mm(12)

st.header("Word doc re-formatter")

docx_file = st.file_uploader("Choose Word document (.docx) to convert", 'docx')

if docx_file is not None:
    document = Document(docx_file)
    make_a4(document)
    set_margins(document)

    for table in document.tables:
        # st.write(table)
        table.autofit = True
        for row in table.rows:
        #     row_data = []
            for cell in row.cells:
                cell.autofit = True
        #         row_data.extend(paragraph.text for paragraph in cell.paragraphs)
        #     st.write("\t".join(row_data))
    document.save("tmp.docx")