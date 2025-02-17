﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using THACO.Web.Service.Constants;
using THACO.Web.Service.Interfaces.Entities;

namespace THACO.Web.Service.Model
{
    public class TimeSheetTargetDtoEdit : TimeSheetTargetEntity, IRecordState, IRecordVersion
    {
        public ModelState state { get; set; }
        public long RecordVersion { get; set; }

        public TimeSheetTargetDtoEdit Clone()
        {
            return (TimeSheetTargetDtoEdit)MemberwiseClone();
        }
    }
}
