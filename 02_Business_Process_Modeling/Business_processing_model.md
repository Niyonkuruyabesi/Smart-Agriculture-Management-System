# PHASE II: Business Process Modeling  
## Smart Farm Management Using IoT Sensors

---

## BPMN Diagram – Smart Farm IoT Process

The following BPMN swimlane diagram illustrates the Smart Farm Management process, showing clear responsibilities, decision points, and data flow among the Farm Manager, IoT System, and Farm Employee.

![Smart Farm IoT BPMN Diagram](Screenshots/BPMN.png)

---

## 1. Scope Definition

### Business Process Overview
This business process models the daily monitoring and management of a smart farm using Internet of Things (IoT) technology. The process integrates automated sensor-based data collection with human decision-making to improve farm efficiency and productivity.

### MIS Relevance
The process is relevant to Management Information Systems (MIS) as it supports:
- Real-time data collection and processing
- Automated operational control
- Managerial decision support
- Reporting and analytics

It aligns with MIS areas such as operations management, inventory/resource management, and decision support systems.

### Objectives
- Monitor farm conditions in real time
- Automate irrigation and greenhouse climate control
- Support managerial approvals for critical actions
- Maintain accurate operational records

### Expected Outcomes
- Improved crop yield and livestock health
- Efficient use of water and resources
- Faster response to anomalies
- Reliable data for planning and forecasting

---

## 2. Identification of Key Entities

### Users
- **Farm Manager** – Oversees farm operations, reviews reports, and approves major interventions
- **Farm Employee** – Executes field tasks, responds to alerts, and updates records

### Systems / Departments
- **IoT Monitoring System** – Collects sensor data, triggers automated actions, and generates alerts
- **MIS Dashboard & Database** – Stores data, generates reports, and supports analytics

### Data Sources
- Soil moisture sensors
- Temperature and humidity sensors
- Livestock health and location sensors
- Manual updates from farm employees

---

## 3. Roles and Responsibilities

| Actor | Responsibilities |
|------|------------------|
| Farm Manager | Reviews alerts and reports, approves critical actions |
| IoT System | Collects sensor data, automates irrigation and greenhouse control |
| Farm Employee | Monitors field activities, resolves issues, updates records |

---

## 4. Swimlane Usage

The BPMN diagram uses three swimlanes to clearly separate responsibilities:
1. Farm Manager
2. IoT System
3. Farm Employee

Swimlanes show clear handoff points, such as managerial approval triggering system actions and system alerts prompting employee responses.

---

## 5. BPMN / UML Notation Application

The diagram correctly applies BPMN conventions:
- **Start Event** – Daily monitoring initiation
- **Tasks** – Review alerts, collect sensor data, activate irrigation, update records
- **Decision Gateways** – Approve Action?, Moisture Low?, Respond to Issues?
- **End Events** – Process completion
- **Data Flow** – Sensor data and alerts flow from IoT System to Employees and Manager

---

## 6. Logical Flow and Dependencies

The process flows logically from start to end:
1. Monitoring begins
2. Sensor data is collected
3. Decisions are made based on thresholds and approvals
4. Automated or manual actions are executed
5. Records are updated and the process ends

Dependencies are correctly structured:
- Automated actions depend on sensor thresholds
- Manual actions depend on alerts
- Critical actions require managerial approval

---

## 7. MIS Functions and Organizational Impact

### MIS Functions
- Data collection and storage
- Processing and analysis
- Decision support via dashboards
- Reporting and performance monitoring

### Organizational Impact
- Reduced operational costs
- Improved efficiency and productivity
- Better strategic planning
- Increased accountability and transparency

---

## 8. Analytics Opportunities

The system enables:
- Predictive irrigation scheduling
- Trend analysis of crop yield and livestock health
- Resource utilization optimization
- Performance monitoring through dashboards

---

## Conclusion
The Smart Farm IoT BPMN model demonstrates effective integration of automation, data management, and human decision-making within an MIS framework. The swimlane-based BPMN diagram clearly shows responsibilities, decision points, and data flow, making it suitable for enterprise-level MIS implementation and analytics-driven management.

