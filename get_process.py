import psutil
INSTANCE = ['-Discream']
PROCESS = 'java'

def pid(process_name):
        """
            process_name: System Process Name
            return: Process name's pid, integer
        """
        for proc in psutil.process_iter():
            try:
                pinfo = proc.as_dict(attrs=['pid', 'name', 'cmdline'])
                if (PROCESS in pinfo['name'] and INSTANCE in pinfo['cmdline']):
                    return pinfo['pid']

            except psutil.NoSuchProcess:
                pass

P = pid(PROCESS)

data = {"pid": process.pid,
        "status": process.status(),
        "percent_cpu_used": process.cpu_percent(interval=0.0),
        "percent_memory_used": process.memory_percent()}


print(data)
