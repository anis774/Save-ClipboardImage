# 配置

C:\Users\user_name\Documents\WindowsPowerShell\ModulesにSave-ClipboardImageフォルダを作成し、そこにSave-ClipboardImage.psm1を配置します。

# 使用例

~~~powershell
Save-ClipboardImage 'file_path'
~~~
フォーマットを指定('BMP', 'PNG', 'JPG', 'GIF')

~~~powershell
Save-ClipboardImage 'file_path' -ImageFormat PNG
~~~
強制保存

~~~powershell
Save-ClipboardImage 'file_path' -Force
~~~
