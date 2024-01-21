# Developed by Cai Lemieux Mack (kailani.j.lemieux.mack@vanderbilt.edu)
#   for BrainHack Vanderbilt January 2024

from pathlib import Path
import sys
# pip install weasyprint
from weasyprint import HTML


def makepdf(html):
    """Generate a PDF file from a string of HTML."""
    htmldoc = HTML(string=html, base_url="")
    return htmldoc.write_pdf(presentational_hints=True)



def run():
    """Command runner."""
    infile = sys.argv[1]
    SubNum = sys.argv[4]
    pdf_outfile = sys.argv[2] + "/sub" + SubNum + ".pdf"
    html_outfile = sys.argv[2] + "/sub" + SubNum + ".html"
    html = Path(infile).read_text()
    # Replace the {ImgPath} pace holder with the path to the png files
    html = html.replace("{ImgPath}", sys.argv[3])
    # Replace the {SubNum} place holder in the html template with the passed in subject number
    html = html.replace("{SubNum}", SubNum)
    pdf = makepdf(html)
    Path(pdf_outfile).write_bytes(pdf)
    Path(html_outfile).write_text(html)

    #

# Syntax is: python3 generate_pdf.py <path to html template> <path to output files> <path to pngs> <subject number>
if __name__ == "__main__":
    run()