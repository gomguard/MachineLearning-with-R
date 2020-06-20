sudo pip3 install jupyterlab
jupyter lab --generate-config



sudo nano ./.jupyter/jupyter_notebook_config.py

c.LabApp.allow_origin = '*'
c.LabApp.notebook_dir = '/home'
# 경로 설정한 대로 실행 됨.
# 경로 이상해서 권한 없으면 신규 노트북 생성 불가
c.LabApp.ip = '222.112.130.112'
c.LabApp.password = u'sha1:6d2796c48700:d441c0f8e515c9eb47fd60895069794fe1172dbf'
c.LabApp.open_browser = False

c.NotebookApp.allow_origin = '*'
c.NotebookApp.notebook_dir = '/home'
c.NotebookApp.ip = '222.112.130.112'
c.NotebookApp.password = u'sha1:6d2796c48700:d441c0f8e515c9eb47fd60895069794fe1172dbf'
c.NotebookApp.open_browser = False

ipython

from notebook.auth import passwd

passwd()

# output 부분 


