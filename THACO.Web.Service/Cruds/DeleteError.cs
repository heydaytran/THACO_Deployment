﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace THACO.Web.Service.Cruds
{
    public class DeleteError
    {
        public int Index { get; set; }
        public string Code { get; set; }
        public object Data { get; set; }
    }
}
